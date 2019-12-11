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

using System;
using System.IO;
using System.Text.RegularExpressions;

namespace CopyrightFixer
{
    // In swagger-codegen template there may be no variable for file
    // name that is required in copyright text. In case there is no
    // other variables with suitable value this script can fix copyright.
    internal class Program
    {
        /// <summary>
        ///     Sets filename to copyright
        /// </summary>
        /// <param name="args">
        ///     Array:
        ///     0 - Path to directory with files;
        ///     1 - regex for filtering file by name (optional)
        /// </param>
        /// <exception cref="ArgumentException">Invalid directory with models</exception>
        public static int Main(string[] args)
        {
            try
            {
                var modelsDirectory = args[0];

                if (!Directory.Exists(modelsDirectory))
                    throw new ArgumentException("Invalid directory with models: " + modelsDirectory);

                var filter = args.Length == 2 ? args[1] : null;

                var fileInfos = new DirectoryInfo(modelsDirectory).GetFiles();

                foreach (var fileInfo in fileInfos)
                {
                    if (filter != null && Regex.IsMatch(fileInfo.Name, filter))
                        continue;

                    var content = File.ReadAllText(fileInfo.FullName);

                    var modifiedContent = Regex.Replace(content, $"(file=\")(.*.{fileInfo.Extension})(\">)", m =>
                        m.Groups[1].Value +
                        fileInfo.Name +
                        m.Groups[3].Value
                    );

                    File.WriteAllText(fileInfo.FullName, modifiedContent);
                }

                return 0;
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Invalid parameters. Please, provide path to directory with models.");

                return 1;
            }
            catch (ArgumentException e)
            {
                Console.WriteLine(e.Message);

                return 1;
            }
        }
    }
}