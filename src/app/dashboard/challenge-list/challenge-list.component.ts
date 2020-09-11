import { Component, OnInit } from '@angular/core';
import { ChallengeService } from '../../challenge.service';
import { Challenge } from '../../entities/challenge-common';

@Component({
  selector: 'app-challenge-list',
  templateUrl: './challenge-list.component.html',
  styleUrls: ['./challenge-list.component.sass']
})
export class ChallengeListComponent implements OnInit {
  challenges: Challenge[];

  constructor(
    private challengeService: ChallengeService,
  ) { }

  ngOnInit(): void {
    this.challengeService.list().subscribe(
      list => this.challenges = list
    );
  }

}
