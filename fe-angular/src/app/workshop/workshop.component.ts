import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormArray, Validators } from '@angular/forms';
import { Challenge, Task } from '../entities/challenge-common';
import { ChallengeService } from '../challenge.service';
import { Router } from '@angular/router';
import { throwError, Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';
import {
  Breakpoints,
  BreakpointObserver,
  BreakpointState,
} from '@angular/cdk/layout';
import { animate, trigger, transition, style } from '@angular/animations';

@Component({
  selector: 'app-workshop',
  templateUrl: './workshop.component.html',
  styleUrls: ['./workshop.component.sass'],
  animations: [
    trigger('TaskAppearing', [
      transition(':enter', [
        style({ transform: 'translateX(50%)', height: 0 }),
        animate('200ms', style({ height: '*', transform: 'translateX(0%)' })),
      ]),
      transition(':leave', [
        animate('200ms', style({ height: 0, transform: 'translateX(50%)' })),
      ]),
    ]),
  ],
})
export class WorkshopComponent implements OnInit {
  challengeForm: FormGroup;
  tasksForm: FormArray;
  layoutChanges$: Observable<BreakpointState>;
  isSmallScreen: boolean;

  constructor(
    private _fb: FormBuilder,
    private _challengeService: ChallengeService,
    private _r: Router,
    private _sb: MatSnackBar,
    private _bpo: BreakpointObserver
  ) {}

  ngOnInit(): void {
    this.checkScreenWidth();
    this.challengeForm = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
    });
    this.tasksForm = this._fb.array([
      this._fb.group({
        title: ['', Validators.required],
        type: ['once', Validators.required],
      }),
    ]);
  }

  checkScreenWidth(): void {
    this.isSmallScreen = this._bpo.isMatched('(max-width: 900px)');
  }

  addTask() {
    this.tasksForm.push(
      this._fb.group({
        title: ['', Validators.required],
        type: ['once', Validators.required],
      })
    );
  }

  removeTask(index: number) {
    this.tasksForm.removeAt(index);
  }

  finish() {
    if (this.challengeForm.invalid || this.tasksForm.invalid) {
      this._sb.open('Please, fill all fields', 'Close', { duration: 3000 });
      return;
    }

    let newChallenge = new Challenge();
    newChallenge.title = this.challengeForm.value.title;
    newChallenge.description = this.challengeForm.value.description;

    let newTasks: Task[] = [];
    for (let task of this.tasksForm.controls) {
      let newTask = new Task();
      newTask.title = task.value.title;
      newTask.type = task.value.type;
      newTasks.push(newTask);
    }

    newChallenge.tasks = newTasks;

    this._challengeService
      .createChallenge(newChallenge)
      .pipe(
        catchError((error) => {
          this._sb.open('Sorry, something went wrong', 'Close', {
            duration: 3000,
          });
          return throwError(error);
        })
      )
      .subscribe((_) => this._r.navigate(['/']));
  }
}
