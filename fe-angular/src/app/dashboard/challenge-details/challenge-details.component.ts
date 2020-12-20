import { Component, OnInit, Input } from '@angular/core';
import { ChallengeService } from '../../challenge.service';
import { Challenge, Task } from '../../entities/challenge-common';
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
  daysTasks: Task[];
  onceTasks: Task[];

  constructor(private challengeService: ChallengeService) {}

  ngOnInit(): void {
    this.challengeId.subscribe((newId) => {
      this.challengeService.getById(newId).subscribe((challenges) => {
        if (challenges.length) {
          this.challenge = challenges[0];
          this.daysTasks = this.challenge.tasks.filter((task) => {
            return task.type == 'days';
          });
          this.onceTasks = this.challenge.tasks.filter((task) => {
            return task.type == 'once';
          });
        }
      });
    });
  }
}
