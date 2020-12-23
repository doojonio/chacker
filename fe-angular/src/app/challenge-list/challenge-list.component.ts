import { Component, OnInit } from '@angular/core';

import { Challenge } from '../challenge';
import { ChallengeService } from '../challenge.service';

@Component({
  selector: 'app-challenge-list',
  templateUrl: './challenge-list.component.html',
  styleUrls: ['./challenge-list.component.sass'],
})
export class ChallengeListComponent implements OnInit {
  challenges: Challenge[];

  constructor(private _challengeService: ChallengeService) {}

  ngOnInit(): void {
    this.fetchChallenges();
  }

  fetchChallenges(): void {
    this._challengeService.list().subscribe((challenges) => {
      this.challenges = challenges;
    });
  }
}
