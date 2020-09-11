import { Component, OnInit } from '@angular/core';
import { ChallengeService } from '../challenge.service';
import { Challenge } from '../entities/challenge-common';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.sass']
})
export class DashboardComponent implements OnInit {

  constructor() { }

  ngOnInit(): void { }

}
