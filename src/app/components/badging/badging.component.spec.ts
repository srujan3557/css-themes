import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BadgingComponent } from './badging.component';

describe('BadgingComponent', () => {
  let component: BadgingComponent;
  let fixture: ComponentFixture<BadgingComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BadgingComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BadgingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
