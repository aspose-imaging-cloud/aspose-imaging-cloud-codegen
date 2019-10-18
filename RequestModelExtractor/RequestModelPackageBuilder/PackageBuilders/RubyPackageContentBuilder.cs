// --------------------------------------------------------------------------------------------------------------------
// <copyright company="Aspose" file="RubyPackageBuilder.cs">
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
using System.Collections.Generic;
using System.IO;

namespace RequestModelPackageBuilder.PackageBuilders
{
    /// <summary>
    ///     The interface containing operations for building a content of a package file for Ruby.
    /// </summary>
    internal class RubyPackageContentBuilder : IPackageContentBuilder
    {
        /// <inheritdoc />
        public IEnumerable<string> IncludeFiles(ICollection<FileInfo> fileInfos, string packageName)
        {
            var imports = new List<string>(fileInfos.Count + 2) {$"{Environment.NewLine}# Request models"};

            foreach (var fileInfo in fileInfos)
            {
                if (!fileInfo.Name.EndsWith("_request.rb"))
                    continue;

                var pyIndex = fileInfo.Name.IndexOf(".rb", StringComparison.Ordinal);
                var fileName = fileInfo.Name
                    .Substring(0, pyIndex);

                var item = $"require_relative './{packageName}/models/requests/{fileName}'";

                imports.Add(item);
            }

            imports.Add(Environment.NewLine);

            return imports;
        }
    }
}