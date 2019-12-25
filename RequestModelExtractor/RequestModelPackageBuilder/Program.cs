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
using System.Linq;
using RequestModelPackageBuilder.PackageBuilders;

namespace RequestModelPackageBuilder
{
    /// <summary>
    ///     All classes in Python should be included in __init__.py
    ///     and all classes in Ruby should be included in gem file
    ///     to be imported from external code. Swagger-codegen processes
    ///     models and api classes, but not the request models. This
    ///     script collects all classes from *_request.py files in
    ///     provided directory and includes them into __init__.py for Python
    ///     or all classes from *_request.rb files and includes them into
    ///     gem file for Ruby.
    ///     Ruby or Python is decided by file definition.
    /// </summary>
    internal class Program
    {
        /// <summary>
        ///     Includes request models' class name to __init__.py/gem file.
        /// </summary>
        /// <param name="args">
        ///     Array:
        ///     0 - Path to directory with request models
        ///     1 - Path to __init__.py file or gem file
        ///     2 - Package name
        /// </param>
        /// <exception cref="ArgumentException">Invalid directory with request models</exception>
        public static int Main(string[] args)
        {
            try
            {
                var modelsDirectory = args[0];
                var outputFile = args[1];
                var packageName = args[2];

                if (!Directory.Exists(modelsDirectory))
                    throw new ArgumentException(
                        $"Invalid directory with models: {modelsDirectory}. Directory doesn't exist.");

                var fileInfos = new DirectoryInfo(modelsDirectory).GetFiles();

                var extension = outputFile.Split('.').LastOrDefault() ??
                                throw new ArgumentException(
                                    $"Invalid package file: {outputFile}. Package file must end with .py or .rb.");

                IPackageContentBuilder packageContentBuilder;
                switch (extension)
                {
                    case "py":
                        packageContentBuilder = new PythonPackageContentBuilder();
                        break;
                    case "rb":
                        packageContentBuilder = new RubyPackageContentBuilder();
                        break;
                    default:
                        throw new ArgumentException(
                            $"Invalid package file: {outputFile}. Package file must end with .py or .rb.");
                }

                var imports = packageContentBuilder.IncludeFiles(fileInfos, packageName);

                File.AppendAllText(outputFile, string.Join(Environment.NewLine, imports.ToArray()));

                return 0;
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Invalid parameters. Please, provide three parameters: path to directory with " +
                                  "models, path to __init__.py or gem file, package name.");

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