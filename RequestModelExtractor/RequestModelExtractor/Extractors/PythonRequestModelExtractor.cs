// --------------------------------------------------------------------------------------------------------------------
// <copyright company="Aspose" file="Program.cs">
//   Copyright (c) 2019 Aspose Pty Ltd. All rights reserved.
// </copyright>
// <summary>
//   Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

using System.Linq;
using System.Text.RegularExpressions;

namespace RequestModelExtractor.Extractors
{
    internal class PythonRequestModelExtractor : Base.RequestModelExtractor
    {
        protected override string FileExtension => "py";
        protected override string CopyrightStart => "#  coding:";

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