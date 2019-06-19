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

                    var modifiedContent = Regex.Replace(content, "(file=\")(.*.py)(\">)", m =>
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