import { Component, OnInit, Inject } from '@angular/core';
import { ENVIRONMENT } from '@com-delta-mts/angular-environment';
export interface Template {
  value: string;
  viewValue: string;
}
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {

  private themeWrapper = document.body.style;

  title = 'CSS Themes Library';
  settings = false;
  currentSettings;
  templates: any[] = [
    {
      id: 'delta',
      label: 'Delta',
      loyaltyTiers: [
        {
          name: 'Delta 360',
          abbrev: '360'
        },
        {
          name: 'Diamond Medallion',
          abbrev: 'DM'
        },
        {
          name: 'Platinum Medallion',
          abbrev: 'PM'
        },
        {
          name: 'Gold Medallion',
          abbrev: 'DM'
        },
        {
          name: 'Silver Medallion',
          abbrev: 'SM'
        },
        {
          name: 'Skymiles Medallion',
          abbrev: 'M'
        },
      ]
    },
    {
      id: 'contrast',
      label: 'Delta Contrast',
      loyaltyTiers: [
        {
          name: 'Delta 360',
          abbrev: '360'
        },
        {
          name: 'Diamond Medallion',
          abbrev: 'DM'
        },
        {
          name: 'Platinum Medallion',
          abbrev: 'PM'
        },
        {
          name: 'Gold Medallion',
          abbrev: 'DM'
        },
        {
          name: 'Silver Medallion',
          abbrev: 'SM'
        },
        {
          name: 'Skymiles Medallion',
          abbrev: 'M'
        },
      ]
    },
    {
      id: 'virgin',
      label: 'Virgin Atlantic',
      loyaltyTiers: [
        {
          name: 'Red',
          abbrev: 'FF'
        },
        {
          name: 'Silver',
          abbrev: 'FO'
        },
        {
          name: 'Gold',
          abbrev: 'GM'
        }
      ]
    }
  ];
  selectedTemplate = 'delta';
  isLoading = false;

  constructor(@Inject(ENVIRONMENT) private environment: any) {
  }

  ngOnInit() {
    console.log('App Configuration', this.environment);
    this.setCSSTheme('delta');
  }

  toggleSettings() {
    this.settings = !this.settings;
  }

  onTemplateChange() {
    console.log('this.selectedTemplate: ', this.selectedTemplate);
    this.setCSSTheme(this.selectedTemplate);
  }

  setCSSTheme(id = this.selectedTemplate): void {
    const theme = this.environment[id].properties;
    if (theme) {
      const keys = Object.keys(theme);
      // Object.values() no support for IE11+
      const values = Object.keys(theme).map( key => theme[key] );
      keys.map( (key, i) => {
        const val: any = values[i];
        this.themeWrapper.setProperty(key, val);
      });

      this.currentSettings = this.templates.filter( template => template.id === id);
      console.log('Current Settings: ', this.currentSettings);
    }
  }

}
