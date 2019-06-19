using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace RequestModelPythonPackageBuilder
{
    // All classes in Python should be included in __init__.py
    // to be imported from external code. Swagger-codegen processes
    // models and api classes, but not the request models. This
    // script collects all classes from *_request.py files in
    // provided directory and includes them into __init__.py.
    internal class Program
    {
        /// <summary>
        ///     Includes request models' class name to __init__.py
        /// </summary>
        /// <param name="args">
        ///     Array:
        ///     0 - Path to directory with request models
        ///     1 - Path to __init__.py file
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
                    throw new ArgumentException("Invalid directory with models: " + modelsDirectory);

                var fileInfos = new DirectoryInfo(modelsDirectory).GetFiles();
                var imports = new List<string>(fileInfos.Length + 1);

                foreach (var fileInfo in fileInfos)
                {
                    if (!fileInfo.Name.EndsWith("_request.py"))
                        continue;

                    var pyIndex = fileInfo.Name.IndexOf(".py", StringComparison.Ordinal);
                    var fileName = fileInfo.Name
                        .Substring(0, pyIndex);
                    var className = string.Join(string.Empty,
                        fileName.Split('_').Select(s => s.Substring(0, 1).ToUpperInvariant() + s.Substring(1))
                            .ToArray());

                    var item = $"from {packageName}.{fileName} import {className}";
                    if (item.Length > 120)
                        item = item.Insert(item.LastIndexOf(' ') + 1, $"\\{Environment.NewLine}    ");

                    imports.Add(item);
                }

                imports.Add(Environment.NewLine);

                File.AppendAllText(outputFile, string.Join(Environment.NewLine, imports.ToArray()));

                return 0;
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Invalid parameters. Please, provide three parameters: path to directory with " +
                                  "models, path to __init__.py and package name.");

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