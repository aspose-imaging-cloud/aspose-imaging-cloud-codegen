// --------------------------------------------------------------------------------------------------------------------
// <copyright company="Aspose" file="Program.cs">
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

namespace CSharpRequestModelExtractor
{
    using System;
    using System.IO;
    using System.Text.RegularExpressions;

    class Program
    {
        static void Main(string[] args)
        {
            DirectoryInfo apiFolderInfo = new DirectoryInfo(args[0]);
            DirectoryInfo modelFolderInfo;
            if (!Directory.Exists(args[1]))
            {
                modelFolderInfo = Directory.CreateDirectory(args[1]);
            }
            else
            {
                modelFolderInfo = new DirectoryInfo(args[1]);
            }

            if (apiFolderInfo.Exists)
            {
                FileInfo[] fileInfos = apiFolderInfo.GetFiles();
                string text, newFileName, contents;
                foreach (FileInfo fileInfo in fileInfos)
                {
                    text = File.ReadAllText(fileInfo.FullName);
                    MatchCollection matchCollection = Regex.Matches(text, "// <copyright company=\"Aspose\" file=\"(.*?).cs\">");
                    int startIndex;
                    for (int index = matchCollection.Count - 1; index > 0; --index)
                    {
                        newFileName = matchCollection[index].Groups[1] + ".cs";
                        startIndex = text.IndexOf("file=\"" + newFileName + "\"") - 152;
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
                    "CSharpRequestModelExtractor 1st argument is swagger-generated API folder path");
            }
        }
    }
}
