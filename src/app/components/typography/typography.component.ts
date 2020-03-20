import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-typography',
  templateUrl: './typography.component.html',
  styleUrls: ['./typography.component.scss']
})
export class TypographyComponent implements OnInit {

  @Input() currentSettings;

  constructor() { }

  ngOnInit() {
  }

}
