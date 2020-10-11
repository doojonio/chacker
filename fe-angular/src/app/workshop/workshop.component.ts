import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormArray, Validators } from '@angular/forms';
import { Challenge, Task } from '../entities/challenge-common';
import { ChallengeService } from '../challenge.service';
import { Router } from '@angular/router';
import { throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';
import {
  animate,
  trigger,
  transition,
  style,
} from '@angular/animations';

@Component({
  selector: 'app-workshop',
  templateUrl: './workshop.component.html',
  styleUrls: ['./workshop.component.sass'],
  animations: [
    trigger('TaskAppearing', [
      transition(':enter', [
        style({ transform: 'translateX(50%)', height: 0 }),
        animate('200ms', style({height: '*', transform: 'translateX(0%)'}))
      ]),
      transition(':leave', [
        animate('200ms', style({ height: 0, transform: 'translateX(50%)'}))
      ]),
    ]),
  ]
})
export class WorkshopComponent implements OnInit {
  challenge: FormGroup;
  tasks: FormArray;

  constructor(
    private _fb: FormBuilder,
    private _challengeService: ChallengeService,
    private _r: Router,
    private _sb: MatSnackBar,
  ) { }

  ngOnInit(): void {
    this.challenge = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
    });
    this.tasks = this._fb.array([
      this._fb.group({
        title: ['', Validators.required],
        description: ['', Validators.required],
        type: ['once', Validators.required],
      })
    ])
  }

  addTask() {
    this.tasks.push(this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      type: ['once', Validators.required],
    }));
  }

  removeTask(index:number) {
    this.tasks.removeAt(index);
  }

  finish() {
    if (this.challenge.hasError || this.tasks.hasError) {
      this._sb.open("Please, fill all fields", "Close", { duration: 3000 });
      return;
    }

    let newChallenge         = new Challenge();
    newChallenge.title       = this.challenge.value.title;
    newChallenge.description = this.challenge.value.description;

    let newTasks:Task[] = [];
    for (let task of this.tasks.controls) {
      let newTask = new Task();
      newTask.title = task.value.title;
      newTask.type = task.value.type;
      newTasks.push(newTask);
    }

    newChallenge.tasks = newTasks;

    this._challengeService.createChallenge(newChallenge).pipe(
      catchError( error => {
        this._sb.open("Sorry, something went wrong", "Close", { duration: 3000 });
        return throwError(error)
      })
    ).subscribe(
      _ => this._r.navigate(["/"])
    )
  }
}
