<?php

namespace Peekmo\AtomAutocompletePhp;

use ReflectionClass;
use ReflectionMethod;
use ReflectionProperty;
use ReflectionFunctionAbstract;

abstract class Tools
{
    /**
     * Contains classmap from composer
     * @var array
     */
    private $classMap = array();

    /**
     * Returns the classMap from composer.
     * Fetch it from the command dump-autoload if needed
     * @param bool $force Force to fetch it from the command
     * @return array
     */
    protected function getClassMap($force = false)
    {
        if (empty($this->classMap) || $force) {
            if (Config::get('classmap_file') && !file_exists(Config::get('classmap_file')) || $force) {
                // Check if composer is executable or not
                if (is_executable(Config::get('composer'))) {
                    exec(sprintf('%s dump-autoload --optimize --quiet --no-interaction --working-dir=%s 2>&1',
                        escapeshellarg(Config::get('composer')),
                        escapeshellarg(Config::get('projectPath'))
                    ));
                } else {
                    exec(sprintf('%s %s dump-autoload --optimize --quiet --no-interaction --working-dir=%s 2>&1',
                        escapeshellarg(Config::get('php')),
                        escapeshellarg(Config::get('composer')),
                        escapeshellarg(Config::get('projectPath'))
                    ));
                }
            }

            if (Config::get('classmap_file')) {
                $this->classMap = require(Config::get('classmap_file'));
            }
        }

        return $this->classMap;
    }

    /**
     * Fetches information about the specified class, trait, interface, ...
     *
     * @param ReflectionClass $class The class to analyze.
     *
     * @return array
     */
   protected function getClassArguments(ReflectionClass $class)
   {
       $parser = new DocParser();
       $docComment = $class->getDocComment() ?: '';

       $docParseResult = $parser->parse($docComment, array(
           DocParser::DEPRECATED,
           DocParser::DESCRIPTION
       ), $class->getShortName());

       return array(
          'descriptions' => $docParseResult['descriptions'],
          'deprecated'   => $docParseResult['deprecated']
      );
   }

    /**
     * Fetches information about the specified method or function, such as its parameters, a description from the
     * docblock (if available), the return type, ...
     *
     * @param ReflectionFunctionAbstract $function The function or method to analyze.
     *
     * @return array
     */
    protected function getMethodArguments(ReflectionFunctionAbstract $function)
    {
        $args = $function->getParameters();

        $optionals = array();
        $parameters = array();

        foreach ($args as $argument) {
            $value = '$' . $argument->getName();

            if ($argument->isPassedByReference()) {
                $value = '&' . $value;
            }

            if ($argument->isOptional()) {
                $optionals[] = $value;
            } else {
                $parameters[] = $value;
            }
        }

        // For variadic methods, append three dots to the last argument (if any) to indicate this to the user. This
        // requires PHP >= 5.6.
        if (!empty($args) && method_exists($function, 'isVariadic') && $function->isVariadic()) {
            $lastArgument = $args[count($args) - 1];

            if ($lastArgument->isOptional()) {
                $optionals[count($optionals) - 1] .= '...';
            } else {
                $parameters[count($parameters) - 1] .= '...';
            }
        }

        $parser = new DocParser();
        $docComment = $function->getDocComment();

        $docParseResult = $parser->parse($docComment, array(
            DocParser::THROWS,
            DocParser::PARAM_TYPE,
            DocParser::DEPRECATED,
            DocParser::DESCRIPTION,
            DocParser::RETURN_VALUE
        ), $function->name);

        $docblockInheritsLongDescription = false;

        // Ticket #86 - Add support for inheriting the entire docblock from the parent if the current docblock contains
        // nothing but these tags. Note that, according to draft PSR-5 and phpDocumentor's implementation, this is
        // incorrect. However, some large frameworks (such as Symfony) use this and it thus makes life easier for many
        // developers, hence this workaround.
        if (in_array($docParseResult['descriptions']['short'], array('{@inheritdoc}', '{@inheritDoc}'))) {
            $docComment = false; // Pretend there is no docblock.
        }

        if (strpos($docParseResult['descriptions']['long'], DocParser::INHERITDOC) !== false) {
            // The parent docblock is embedded, which we'll need to parse. Note that according to phpDocumentor this
            // only works for the long description (not the so-called 'summary' or short description).
            $docblockInheritsLongDescription = true;
        }

        // No immediate docblock available or we need to scan the parent docblock?
        if ((!$docComment || $docblockInheritsLongDescription) && $function instanceof ReflectionMethod) {
            $classIterator = new ReflectionClass($function->class);
            $classIterator = $classIterator->getParentClass();

            // Check if this method is implementing an abstract method from a trait, in which case that docblock should
            // be used.
            if (!$docComment) {
                foreach ($function->getDeclaringClass()->getTraits() as $trait) {
                    if ($trait->hasMethod($function->getName())) {
                        $traitMethod = $trait->getMethod($function->getName());

                        if ($traitMethod->isAbstract() && $traitMethod->getDocComment()) {
                            return $this->getMethodArguments($traitMethod);
                        }
                    }
                }
            }

            // Check if this method is implementing an interface method, in which case that docblock should be used.
            // NOTE: If the parent class has an interface, getMethods() on the parent class will include the interface
            // methods, along with their docblocks, even if the parent doesn't actually implement the method. So we only
            // have to check the interfaces of the declaring class.
            if (!$docComment) {
                foreach ($function->getDeclaringClass()->getInterfaces() as $interface) {
                    if ($interface->hasMethod($function->getName())) {
                        $interfaceMethod = $interface->getMethod($function->getName());

                        if ($interfaceMethod->getDocComment()) {
                            return $this->getMethodArguments($interfaceMethod);
                        }
                    }
                }
            }

            // Walk up base classes to see if any of them have additional info about this method.
            while ($classIterator) {
                if ($classIterator->hasMethod($function->getName())) {
                    $baseClassMethod = $classIterator->getMethod($function->getName());

                    if ($baseClassMethod->getDocComment()) {
                        $baseClassMethodArgs = $this->getMethodArguments($baseClassMethod);

                        if (!$docComment) {
                            return $baseClassMethodArgs; // Fall back to parent docblock.
                        } elseif ($docblockInheritsLongDescription) {
                            $docParseResult['descriptions']['long'] = str_replace(
                                DocParser::INHERITDOC,
                                $baseClassMethodArgs['descriptions']['long'],
                                $docParseResult['descriptions']['long']
                            );
                        }

                        break;
                    }
                }

                $classIterator = $classIterator->getParentClass();
            }
        }

        return array(
            'parameters'    => $parameters,
            'optionals'     => $optionals,
            'docParameters' => $docParseResult['params'],
            'throws'        => $docParseResult['throws'],
            'return'        => $docParseResult['return'],
            'descriptions'  => $docParseResult['descriptions'],
            'deprecated'    => $function->isDeprecated() || $docParseResult['deprecated']
        );
    }

     /**
      * Fetches information about the specified class property, such as its type, description, ...
      *
      * @param ReflectionProperty $property The property to analyze.
      *
      * @return array
      */
    protected function getPropertyArguments(ReflectionProperty $property)
    {
        $parser = new DocParser();
        $docComment = $property->getDocComment() ?: '';

        $docParseResult = $parser->parse($docComment, array(
            DocParser::VAR_TYPE,
            DocParser::DEPRECATED,
            DocParser::DESCRIPTION
        ), $property->name);

        if (!$docComment) {
            $classIterator = new ReflectionClass($property->class);
            $classIterator = $classIterator->getParentClass();

            // Walk up base classes to see if any of them have additional info about this property.
            while ($classIterator) {
                if ($classIterator->hasProperty($property->getName())) {
                    $baseClassProperty = $classIterator->getProperty($property->getName());

                    if ($baseClassProperty->getDocComment()) {
                        $baseClassPropertyArgs = $this->getPropertyArguments($baseClassProperty);

                        return $baseClassPropertyArgs; // Fall back to parent docblock.
                    }
                }

                $classIterator = $classIterator->getParentClass();
            }
        }

        return array(
           'return'       => $docParseResult['var'],
           'descriptions' => $docParseResult['descriptions'],
           'deprecated'   => $docParseResult['deprecated']
       );
    }

    /**
     * Retrieves the class that contains the specified reflection member.
     *
     * @param ReflectionFunctionAbstract|ReflectionProperty $reflectionMember
     *
     * @return array
     */
    protected function getDeclaringClass($reflectionMember)
    {
        // This will point to the class that contains the member, which will resolve to the parent class if it's
        // inherited (and not overridden).
        $declaringClass = $reflectionMember->getDeclaringClass();

        return array(
            'name'     => $declaringClass->name,
            'filename' => $declaringClass->getFilename()
        );
    }

    /**
     * Retrieves the structure (class, trait, interface, ...) that contains the specified reflection member.
     *
     * @param ReflectionFunctionAbstract|ReflectionProperty $reflectionMember
     *
     * @return array
     */
    protected function getDeclaringStructure($reflectionMember)
    {
        // This will point to the class that contains the member, which will resolve to the parent class if it's
        // inherited (and not overridden).
        $declaringStructure = $reflectionMember->getDeclaringClass();
        $isMethod = ($reflectionMember instanceof ReflectionFunctionAbstract);

        // Members from traits are seen as part of the structure using the trait, but we still want the actual trait
        // name.
        foreach ($declaringStructure->getTraits() as $trait) {
            if (($isMethod && $trait->hasMethod($reflectionMember->name)) ||
                (!$isMethod && $trait->hasProperty($reflectionMember->name))) {
                $declaringStructure = $trait;
                break;
            }
        }

        return array(
            'name'     => $declaringStructure->name,
            'filename' => $declaringStructure->getFilename()
        );
    }

    /**
     * Retrieves information about what the specified member is overriding, if anything.
     *
     * @param ReflectionFunctionAbstract|ReflectionProperty $reflectionMember
     *
     * @return array|null
     */
    protected function getOverrideInfo($reflectionMember)
    {
        $overriddenMember = null;
        $memberName = $reflectionMember->getName();

        $baseClass = $reflectionMember->getDeclaringClass();

        $type = ($reflectionMember instanceof ReflectionProperty) ? 'Property' : 'Method';

        while ($baseClass = $baseClass->getParentClass()) {
            if ($baseClass->{'has' . $type}($memberName)) {
                $overriddenMember = $baseClass->{'get' . $type}($memberName);
                break;
            }
        }

        if (!$overriddenMember) {
            // This method is not an override of a parent method, see if it is an 'override' of an abstract method from
            // a trait the class it is in is using.
            if ($reflectionMember instanceof ReflectionFunctionAbstract) {
                foreach ($reflectionMember->getDeclaringClass()->getTraits() as $trait) {
                    if ($trait->hasMethod($memberName)) {
                        $traitMethod = $trait->getMethod($memberName);

                        if ($traitMethod->isAbstract()) {
                            $overriddenMember = $traitMethod;
                        }
                    }
                }
            }

            if (!$overriddenMember) {
                return null;
            }
        }

        $startLine = null;

        if ($overriddenMember instanceof ReflectionFunctionAbstract) {
            $startLine = $overriddenMember->getStartLine();
        }

        return array(
            'declaringClass'     => $this->getDeclaringClass($overriddenMember),
            'declaringStructure' => $this->getDeclaringStructure($overriddenMember),
            'startLine'          => $startLine
        );
    }

    /**
     * Retrieves information about what interface the specified member method is implementind, if any.
     *
     * @param ReflectionFunctionAbstract $reflectionMember
     *
     * @return array|null
     */
    protected function getImplementationInfo(ReflectionFunctionAbstract $reflectionMember)
    {
        $implementedMember = null;
        $methodName = $reflectionMember->getName();

        foreach ($reflectionMember->getDeclaringClass()->getInterfaces() as $interface) {
            if ($interface->hasMethod($methodName)) {
                $implementedMember = $interface->getMethod($methodName);
                break;
            }
        }

        if (!$implementedMember) {
            return null;
        }

        return array(
            'declaringClass'     => $this->getDeclaringClass($implementedMember),
            'declaringStructure' => $this->getDeclaringStructure($implementedMember),
            'startLine'          => $implementedMember->getStartLine()
        );
    }

    /**
     * Retrieves a list of parent classes of the specified class, ordered from the closest to the furthest ancestor.
     *
     * @param ReflectionClass $class
     *
     * @return string[]
     */
    protected function getParentClasses(ReflectionClass $class)
    {
        $parents = [];

        $parentClass = $class;

        while ($parentClass = $parentClass->getParentClass()) {
            $parents[] = $parentClass->getName();
        }

        return $parents;
    }

    /**
     * Returns methods and properties of the given className
     *
     * @param string $className Full namespace of the parsed class.
     *
     * @return array
     */
    protected function getClassMetadata($className)
    {
        $data = array(
            'wasFound'    => false,
            'class'       => $className,
            'shortName'   => null,
            'filename'    => null,
            'isTrait'     => null,
            'isClass'     => null,
            'isAbstract'  => null,
            'isInterface' => null,
            'parents'     => array(),
            'names'       => array(),
            'values'      => array(),
            'args'        => array()
        );

        try {
            $reflection = new ReflectionClass($className);
        } catch (\Exception $e) {
            return $data;
        }

        $data = array_merge($data, array(
            'wasFound'     => true,
            'shortName'    => $reflection->getShortName(),
            'filename'     => $reflection->getFileName(),
            'isTrait'      => $reflection->isTrait(),
            'isClass'      => !($reflection->isTrait() || $reflection->isInterface()),
            'isAbstract'   => $reflection->isAbstract(),
            'isInterface'  => $reflection->isInterface(),
            'parents'      => $this->getParentClasses($reflection),
            'args'         => $this->getClassArguments($reflection)
        ));

        // Retrieve information about methods.
        foreach ($reflection->getMethods() as $method) {
            $data['names'][] = $method->getName();

            $data['values'][$method->getName()] = array(
                'isMethod'           => true,
                'isProperty'         => false,
                'isPublic'           => $method->isPublic(),
                'isProtected'        => $method->isProtected(),
                'isPrivate'          => $method->isPrivate(),
                'isStatic'           => $method->isStatic(),

                'override'           => $this->getOverrideInfo($method),
                'implementation'     => $this->getImplementationInfo($method),

                'args'               => $this->getMethodArguments($method),
                'declaringClass'     => $this->getDeclaringClass($method),
                'declaringStructure' => $this->getDeclaringStructure($method),
                'startLine'          => $method->getStartLine()
            );
        }

        // Retrieves information about properties/attributes.
        foreach ($reflection->getProperties() as $attribute) {
            if (!in_array($attribute->getName(), $data['names'])) {
                $data['names'][] = $attribute->getName();
                $data['values'][$attribute->getName()] = null;
            }

            $attributesValues = array(
                'isMethod'           => false,
                'isProperty'         => true,
                'isPublic'           => $attribute->isPublic(),
                'isProtected'        => $attribute->isProtected(),
                'isPrivate'          => $attribute->isPrivate(),
                'isStatic'           => $attribute->isStatic(),

                'override'           => $this->getOverrideInfo($attribute),

                'args'               => $this->getPropertyArguments($attribute),
                'declaringClass'     => $this->getDeclaringClass($attribute),
                'declaringStructure' => $this->getDeclaringStructure($attribute)
            );

            if (is_array($data['values'][$attribute->getName()])) {
                $attributesValues = array(
                    $attributesValues,
                    $data['values'][$attribute->getName()]
                );
            }

            $data['values'][$attribute->getName()] = $attributesValues;
        }

        // Retrieve information about constants.
        $constants  = $reflection->getConstants();

        foreach ($constants as $constant => $value) {
            if (!in_array($constant, $data['names'])) {
                $data['names'][] = $constant;
                $data['values'][$constant] = null;
            }

            // TODO: There is no direct way to know where the constant originated from (the current class, a base class,
            // an interface of a base class, a trait, ...). This could be done by looping up the chain of base classes
            // to the last class that also has the same property and then checking if any of that class' traits or
            // interfaces define the constant.
            $data['values'][$constant][] = array(
                'isMethod'       => false,
                'isProperty'     => false,
                'isPublic'       => true,
                'isProtected'    => false,
                'isPrivate'      => false,
                'isStatic'       => true,
                'declaringClass' => array(
                    'name'     => $reflection->name,
                    'filename' => $reflection->getFileName()
                ),

                // TODO: It is not possible to directly fetch the docblock of the constant through reflection, manual
                // file parsing is required.
                'args'           => array(
                    'return'       => null,
                    'descriptions' => array(),
                    'deprecated'   => false
                )
            );
        }

        return $data;
    }
}

?>
