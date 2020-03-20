import 'hammerjs';
import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

// import cssVars from 'css-vars-ponyfill';

// cssVars({
//   include: 'style',
//   onlyLegacy: false,
//   watch: true,
//   preserveStatic: false,
//   preserveVars: true,
//   updateURLs: true,
//   onComplete(cssText, styleNode, cssVariables) {
//     // console.log('CSS Variables: ', cssVariables);
//   }
// });

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));
