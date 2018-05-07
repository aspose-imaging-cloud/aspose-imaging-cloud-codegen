// --------------------------------------------------------------------------------------------------------------------
// <copyright company="Aspose" file="JavaRequestModelExtractor.cs">
//   Copyright (c) 2018 Aspose.Imaging for Cloud
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

namespace RequestModelExtractor.Extractors
{
    using System;
    using System.Text.RegularExpressions;

    /// <inheritdoc />
    internal class JavaRequestModelExtractor : Base.RequestModelExtractor
    {
        /// <inheritdoc />
        protected override int CopyrightOffset => 126;

        /// <inheritdoc />
        protected override string FileExtension => "java";

        /// <inheritdoc />
        protected override string PreProcessRequestModel(string initialApiText)
        {
            string requestClassName;
            int nextIndex;
            char nextChar;
            MatchCollection matchCollection = Regex.Matches(initialApiText, "[a-zA-Z0-9_]+Request");
            foreach (Match match in matchCollection)
            {
                nextIndex = match.Index + match.Length;
                if (nextIndex < initialApiText.Length)
                {
                    nextChar = initialApiText[match.Index + match.Length];
                    if (char.IsLetterOrDigit(nextChar))
                    {
                        // skip other classes
                        continue;
                    }

                    if (nextChar == '(')
                    {
                        // skip other methods, but not needed constructors
                        nextIndex = initialApiText.IndexOf(")", nextIndex) + 1;
                        nextChar = initialApiText[nextIndex];
                        if (nextChar == '.' || nextChar == ';')
                        {
                            continue;
                        }
                    }
                }

                requestClassName = initialApiText.Substring(match.Index, match.Length);
                requestClassName = char.ToUpper(requestClassName[0]) +
                                   requestClassName.Substring(1, requestClassName.Length - 1);
                initialApiText = initialApiText.Remove(match.Index, match.Length)
                    .Insert(match.Index, requestClassName);
            }

            return initialApiText;
        }
    }
}
