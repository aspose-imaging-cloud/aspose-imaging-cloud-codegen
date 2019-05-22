using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace RequestModelPythonPackageBuilder
{
    internal class Program
    {
        public static void Main(string[] args)
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
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Invalid parameters. Please, provide three parameters: path to directory with " +
                                  "models, path to __init__.py and package name.");
                throw;
            }
            catch (ArgumentException e)
            {
                Console.WriteLine(e.Message);
                throw;
            }
        }
    }
}