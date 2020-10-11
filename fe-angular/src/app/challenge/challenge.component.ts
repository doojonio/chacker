import { Input, Component, OnInit } from '@angular/core';
import { Challenge } from '../entities/challenge-common';

@Component({
  selector: 'app-challenge',
  templateUrl: './challenge.component.html',
  styleUrls: ['./challenge.component.sass']
})
export class ChallengeComponent implements OnInit {
  @Input() challenge:Challenge;

  constructor() { }

  ngOnInit(): void {
  }

}
