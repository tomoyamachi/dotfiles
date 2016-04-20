<?php

namespace Peekmo\AtomAutocompletePhp;

class AutocompleteProvider extends Tools implements ProviderInterface
{
    /**
     * Execute the command.
     *
     * @param  array $args Arguments gived to the command.
     *
     * @return array Response
     */
    public function execute($args = array())
    {
        $class = $args[0];
        $name  = $args[1];

        if (strpos($class, '\\') === 0) {
            $class = substr($class, 1);
        }

        $isMethod = false;

        if (strpos($name, '(') !== false) {
            $isMethod = true;
            $name = substr($name, 0, strpos($name, '('));
        }

        $relevantClass = null;
        $data = $this->getClassMetadata($class);

        if (isset($data['values'][$name])) {
            $memberInfo = $data['values'][$name];

            if (!isset($data['values'][$name]['isMethod'])) {
                foreach ($data['values'][$name] as $value) {
                    if ($value['isMethod'] && $isMethod) {
                        $memberInfo = $value;
                    } elseif (!$value['isMethod'] && !$isMethod) {
                        $memberInfo = $value;
                    }
                }
            }

            $returnValue = $memberInfo['args']['return']['type'];

            if ($returnValue == '$this' || $returnValue == 'static') {
                $relevantClass = $class;
            } elseif ($returnValue === 'self') {
                $relevantClass = $memberInfo['declaringClass']['name'];
            } else {
                $soleClassName = $this->getSoleClassName($returnValue);

                if ($soleClassName) {
                    // At this point, this could either be a class name relative to the current namespace or a full
                    // class name without a leading slash. For example, Foo\Bar could also be relative (e.g.
                    // My\Foo\Bar), in which case its absolute path is determined by the namespace and use statements
                    // of the file containing it.
                    $relevantClass = $soleClassName;

                    if (!empty($soleClassName) && $soleClassName[0] !== "\\") {
                        $parser = new FileParser($memberInfo['declaringStructure']['filename']);

                        $useStatementFound = false;
                        $completedClassName = $parser->getFullClassName($soleClassName, $useStatementFound);

                        if ($useStatementFound) {
                            $relevantClass = $completedClassName;
                        } else {
                            $isRelativeClass = true;

                            // Try instantiating the class, e.g. My\Foo\Bar.
                            try {
                                $reflection = new \ReflectionClass($completedClassName);

                                $relevantClass = $completedClassName;
                            } catch (\Exception $e) {
                                // The class, e.g. My\Foo\Bar, didn't exist. We can only assume its an absolute path,
                                // using a namespace set up in composer.json, without a leading slash.
                            }
                        }
                    }
                }
            }
        }

        // Minor optimization to avoid fetching the same data twice.
        return ($relevantClass === $class) ? $data : $this->getClassMetadata($relevantClass);
    }

    /**
     * Retrieves the sole class name from the specified return value statement.
     *
     * @example "null" returns null.
     * @example "FooClass" returns "FooClass".
     * @example "FooClass|null" returns "FooClass".
     * @example "FooClass|BarClass|null" returns null (there is no single type).
     *
     * @param string $returnValueStatement
     *
     * @return string|null
     */
    protected function getSoleClassName($returnValueStatement)
    {
        if ($returnValueStatement) {
            $types = explode(DocParser::TYPE_SPLITTER, $returnValueStatement);

            $classTypes = array();

            foreach ($types as $type) {
                if ($this->isClassType($type)) {
                    $classTypes[] = $type;
                }
            }

            if (count($classTypes) === 1) {
                return $classTypes[0];
            }
        }

        return null;
    }

    /**
     * Returns a boolean indicating if the specified value is a class type or not.
     *
     * @param string $type
     *
     * @return bool
     */
    protected function isClassType($type)
    {
        return ucfirst($type) === $type;
    }
}
