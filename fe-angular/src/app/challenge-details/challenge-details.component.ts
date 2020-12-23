import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { Challenge } from '../challenge';
import { ChallengeService } from '../challenge.service';

@Component({
  selector: 'app-challenge-details',
  templateUrl: './challenge-details.component.html',
  styleUrls: ['./challenge-details.component.sass']
})
export class ChallengeDetailsComponent implements OnInit {
  challengeId: number;
  challenge: Challenge;

  constructor(
    private _route: ActivatedRoute,
    private _challengeService: ChallengeService,
  ) { }

  ngOnInit(): void {
    this._route.paramMap.subscribe(params => {
      this.challengeId = Number(params.get('challengeId'));
      if (this.challengeId) {
        this.fetchChallenge();
      }
    });
  }

  fetchChallenge(): void {
    this._challengeService.getById(this.challengeId).subscribe(challenge => {
        this.challenge = challenge;
      }
    )
  }
}
