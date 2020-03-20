import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-iconography',
  templateUrl: './iconography.component.html',
  styleUrls: ['./iconography.component.scss']
})
export class IconographyComponent implements OnInit {

  @Input() currentSettings;

  constructor() { }

  ngOnInit() {
  }

}
