using System;
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
                var packageName = args[1];


                if (!Directory.Exists(modelsDirectory))
                    throw new ArgumentException("Invalid directory with models: " + modelsDirectory);

                var fileInfos = new DirectoryInfo(modelsDirectory).GetFiles();
                var imports = new string[fileInfos.Length + 1];

                for (var i = 0; i < fileInfos.Length; i++)
                {
                    if (!fileInfos[i].Name.EndsWith("_request.py"))
                        continue;

                    var pyIndex = fileInfos[i].Name.IndexOf(".py", StringComparison.Ordinal);
                    var fileName = fileInfos[i].Name
                        .Substring(0, pyIndex);
                    var className = string.Join(string.Empty,
                        fileName.Split('_').Select(s => s.Substring(0, 1).ToUpperInvariant() + s.Substring(1))
                            .ToArray());
                    imports[i] = $"from {packageName}.{fileName} import {className}";
                }

                imports[fileInfos.Length] = Environment.NewLine;

                File.WriteAllText(modelsDirectory + "__init__.py", string.Join(Environment.NewLine, imports));
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("Invalid parameters. Please, provide two parameters: path to directory with " +
                                  "models and package name.");
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