import { Component, OnInit, Input } from '@angular/core';
import { ChallengeService } from '../../challenge.service';
import { Challenge } from '../../entities/challenge-common';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-challenge-details',
  templateUrl: './challenge-details.component.html',
  styleUrls: ['./challenge-details.component.sass'],
})
export class ChallengeDetailsComponent implements OnInit {
  @Input()
  challengeId: Subject<number>;
  challenge: Challenge;

  constructor(private challengeService: ChallengeService) {}

  ngOnInit(): void {
    this.challengeId.subscribe((newId) => {
      this.challengeService.getById(newId).subscribe((challenges) => {
        if (challenges.length) {
          this.challenge = challenges[0];
        }
      });
    });
  }
}
