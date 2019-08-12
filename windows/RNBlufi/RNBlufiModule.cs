using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Blufi.RNBlufi
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNBlufiModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNBlufiModule"/>.
        /// </summary>
        internal RNBlufiModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNBlufi";
            }
        }
    }
}
