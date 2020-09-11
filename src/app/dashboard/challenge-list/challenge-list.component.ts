import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { ChallengeService } from '../../challenge.service';
import { Challenge } from '../../entities/challenge-common';

@Component({
  selector: 'app-challenge-list',
  templateUrl: './challenge-list.component.html',
  styleUrls: ['./challenge-list.component.sass']
})
export class ChallengeListComponent implements OnInit {
  challenges: Challenge[];
  @Output() detailRequested = new EventEmitter<number>();

  constructor(
    private challengeService: ChallengeService,
  ) { }

  ngOnInit(): void {
    this.challengeService.list().subscribe(
      list => this.challenges = list
    );
  }

  requestDetails(challengeId: number) {
    this.detailRequested.emit(challengeId);
  }
}
