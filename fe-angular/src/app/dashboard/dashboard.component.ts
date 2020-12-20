import { Component, OnInit } from '@angular/core';
import { ChallengeService } from '../challenge.service';
import { Challenge } from '../entities/challenge-common';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.sass'],
})
export class DashboardComponent implements OnInit {
  challenges: Challenge[];
  selectedChallengeId: Subject<number> = new Subject();
  isLoading: boolean = true;

  constructor(private challengeService: ChallengeService) {}

  ngOnInit(): void {
    this.challengeService.list().subscribe((challenges) => {
      this.isLoading = false;
      this.challenges = challenges;
      if (challenges.length) {
        this.selectedChallengeId.next(challenges[0].id);
      }
    });
  }

  selectChallenge(id: number) {
    this.selectedChallengeId.next(id);
  }
}
