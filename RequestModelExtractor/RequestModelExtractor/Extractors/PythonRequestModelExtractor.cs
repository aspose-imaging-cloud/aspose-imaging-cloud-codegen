using System.Linq;
using System.Text.RegularExpressions;

namespace RequestModelExtractor.Extractors
{
    internal class PythonRequestModelExtractor : Base.RequestModelExtractor
    {
        protected override string FileExtension => "py";
        protected override string CopyrightStart => "# coding:";

        protected override string PreProcessRequestModel(string initialApiText)
        {
            return Regex.Replace(initialApiText, "(class |import )(.*_request)(\\(|(\\r\\n|\\r|\\n))", m =>
                $"{m.Groups[1].Value}" +
                $@"{string.Join(string.Empty, m.Groups[2].Value.Split('_')
                    .Select(s => s.Substring(0, 1).ToUpperInvariant() + s.Substring(1)).ToArray())}" +
                $"{m.Groups[3].Value}");
        }

        protected override string ProcessFileName(string fileName)
        {
            return fileName;
        }
    }
}