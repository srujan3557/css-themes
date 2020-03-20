import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-badging',
  templateUrl: './badging.component.html',
  styleUrls: ['./badging.component.scss']
})
export class BadgingComponent implements OnInit {

  @Input() currentSettings;

  constructor() { }

  ngOnInit() {
  }

}
