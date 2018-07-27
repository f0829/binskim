// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.
using System;
using System.Runtime.InteropServices;

namespace Microsoft.CodeAnalysis.BinaryParsers
{
    public static class PlatformSpecificHelpers
    {
        public static bool RunningOnWindows()
        {
            // .NET Core cannot use COM Interop--so we're disabling Windows specific functionality in .Net Core
            // and shipping a .net framework version for Windows.
            // See BinSkim specific details here:
            // https://github.com/Microsoft/binskim/issues/173
            // https://github.com/dotnet/corefx/issues/31405
            // and
            // tracking issue is: https://github.com/dotnet/core-setup/issues/4314
#if NETCOREAPP2_0
            return false;
#else
            return RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
#endif
        }

        public static void ThrowIfNotOnWindows()
        {
            if(!RunningOnWindows())
            {
                throw new PlatformNotSupportedException(
                    string.Format(BinaryParsersResources.PlatformUnsupportedFormat, RuntimeInformation.OSDescription, OSPlatform.Windows));
            }
        }

        public static string GetCurrentOSDescription()
        {
            return RuntimeInformation.OSDescription;
        }
    }
}
