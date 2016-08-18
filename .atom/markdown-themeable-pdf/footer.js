/**
 * Your markdown-themeable-pdf custom footer.
 * After you have made any changes you need to reload or restart atom.
 *
 * The default file can be found in the folder ~/.atom/packages/markdown-themeable-pdf/templates
 *
 * @param Object For example: {fileInfo: base: "Demo.md", dir: ".../markdown-themeable-pdf/tests", ext: ".md", name: "Demo"}, root: "/", exportType: "pdf", destFileBase: "Demo.pdf", destFile: "......./markdown-themeable-pdf/tests/Demo.pdf"}
 * @returns Object {{height: string, contents: string}}
 */
module.exports = function (info) {
    var dateFormat = function () {
        return (new Date()).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    };
    return {
        height: '1cm',
        contents: '<div style="float:left;">' + dateFormat() + '</div>'
    };
};
