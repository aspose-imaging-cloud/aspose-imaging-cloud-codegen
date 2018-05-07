// --------------------------------------------------------------------------------------------------------------------
// <copyright company="Aspose" file="RequestModelExtractor.cs">
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

namespace RequestModelExtractor.Base
{
    using System;
    using System.IO;
    using System.Text.RegularExpressions;
    using Extractors;

    /// <summary>
    /// Extracts the request model from API.
    /// </summary>
    internal abstract class RequestModelExtractor
    {
        #region Properties

        /// <summary>
        /// Gets the copyright offset.
        /// </summary>
        /// <value>
        /// The copyright offset.
        /// </value>
        protected abstract int CopyrightOffset { get; }

        /// <summary>
        /// Gets the file extension.
        /// </summary>
        /// <value>
        /// The file extension.
        /// </value>
        protected abstract string FileExtension { get; }

        #endregion

        #region Methods

        /// <summary>
        /// Creates corresponding request model extractor for the specified language.
        /// </summary>
        /// <param name="language">The language.</param>
        /// <returns></returns>
        internal static RequestModelExtractor Create(string language)
        {
            switch (language)
            {
                case "csharp":
                    return new CSharpRequestModelExtractor();
                case "java":
                    return new JavaRequestModelExtractor();
            }

            throw new NotSupportedException($"Language {language} is not supported");
        }

        /// <summary>
        /// Extracts the request model.
        /// </summary>
        /// <param name="inputDirectory">The input directory.</param>
        /// <param name="outputDirectory">The output directory.</param>
        /// <exception cref="ArgumentException">RequestModelExtractor 1st argument should be swagger-generated API folder path</exception>
        internal void ExtractRequestModel(string inputDirectory, string outputDirectory)
        {
            DirectoryInfo apiFolderInfo = new DirectoryInfo(inputDirectory);
            DirectoryInfo modelFolderInfo;
            if (!Directory.Exists(outputDirectory))
            {
                modelFolderInfo = Directory.CreateDirectory(outputDirectory);
            }
            else
            {
                modelFolderInfo = new DirectoryInfo(outputDirectory);
            }

            if (apiFolderInfo.Exists)
            {
                string text, newFileName, contents;
                FileInfo[] fileInfos = apiFolderInfo.GetFiles();
                foreach (FileInfo fileInfo in fileInfos)
                {
                    text = PreProcessRequestModel(File.ReadAllText(fileInfo.FullName));
                    MatchCollection matchCollection = Regex.Matches(text, $"<copyright company=\"Aspose\" file=\"(.*?).{FileExtension}\">");
                    int startIndex;
                    for (int index = matchCollection.Count - 1; index > 0; --index)
                    {
                        newFileName = $"{matchCollection[index].Groups[1]}.{FileExtension}";
                        newFileName = Char.ToUpper(newFileName[0]) + newFileName.Substring(1, newFileName.Length - 1);
                        startIndex = matchCollection[index].Index - CopyrightOffset;
                        contents = text.Substring(startIndex);
                        text = text.Substring(0, text.Length - contents.Length);
                        File.WriteAllText(modelFolderInfo.FullName + newFileName, contents);
                    }

                    File.WriteAllText(fileInfo.FullName, text);
                }
            }
            else
            {
                throw new ArgumentException(
                    "RequestModelExtractor 1st argument should be swagger-generated API folder path");
            }
        }

        /// <summary>
        /// Pre-process the request model.
        /// </summary>
        /// <param name="initialApiText">The initial API text.</param>
        /// <returns></returns>
        protected abstract string PreProcessRequestModel(string initialApiText);

        #endregion
    }
}
