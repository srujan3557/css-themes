import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { EnvironmentModule } from '@com-delta-mts/angular-environment';
import { AppComponent } from './app.component';
import { MaterialModule } from './core/material/material.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { IconographyComponent } from './components/iconography/iconography.component';
import { BadgingComponent } from './components/badging/badging.component';
import { ColorsComponent } from './components/colors/colors.component';
import { TypographyComponent } from './components/typography/typography.component';

@NgModule({
  declarations: [
    AppComponent,
    IconographyComponent,
    BadgingComponent,
    ColorsComponent,
    TypographyComponent
  ],
  imports: [
    BrowserModule,
    EnvironmentModule,
    BrowserAnimationsModule,
    MaterialModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
