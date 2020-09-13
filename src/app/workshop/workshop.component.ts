import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormArray, Validators } from '@angular/forms';
import { Challenge, Task } from '../entities/challenge-common';
import { ChallengeService } from '../challenge.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-workshop',
  templateUrl: './workshop.component.html',
  styleUrls: ['./workshop.component.sass']
})
export class WorkshopComponent implements OnInit {
  challenge: FormGroup;
  tasks: FormArray;

  constructor(
    private _fb: FormBuilder,
    private _challengeService: ChallengeService,
    private _r: Router,
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
    var newChallenge         = new Challenge();
    newChallenge.title       = this.challenge.value.title;
    newChallenge.description = this.challenge.value.description;

    var newTasks:Task[] = [];
    for (var task of this.tasks.controls) {
      var newTask = new Task();
      newTask.title = task.value.title;
      newTask.type = task.value.type;
      newTasks.push(newTask);
    }

    newChallenge.tasks = newTasks;

    this._challengeService.createChallenge(newChallenge).subscribe(
      _ => this._r.navigate(["/"])
    )
  }
}
