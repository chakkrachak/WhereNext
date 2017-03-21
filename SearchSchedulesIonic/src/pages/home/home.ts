import { Component } from '@angular/core';

import { NavController } from 'ionic-angular';

declare var cordova: any;

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  constructor(public navCtrl: NavController) {
    
  }

  launchView() {
  	cordova.plugins.NavitiaAccessCordova.SearchSchedulesViewController();
  }
}
