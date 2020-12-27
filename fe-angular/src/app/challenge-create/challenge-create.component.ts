import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { Task } from '../task';
import { UploadedImage } from '../uploaded-image';

@Component({
  selector: 'app-challenge-create',
  templateUrl: './challenge-create.component.html',
  styleUrls: ['./challenge-create.component.scss'],
})
export class ChallengeCreateComponent implements OnInit {
  challengeUploadedImage: UploadedImage;
  challengeFormGroup: FormGroup;
  tasks: Task[] = [];

  constructor(private _fb: FormBuilder) {}

  ngOnInit(): void {
    this.challengeFormGroup = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      tasks: this._fb.array([this._generateTaskFormGroup()]),
    });
  }

  onUploadChallengePicture(response: Observable<UploadedImage>) {
    response.subscribe((uploadedImage) => {
      this.challengeUploadedImage = uploadedImage;
    });
  }

  resetChallengeWallpaper() {
    this.challengeUploadedImage = null;
  }

  addTask(task: Task) {
    this.tasks.push(task);
  }

  private _generateTaskFormGroup(): FormGroup {
    return this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      type: ['', Validators.required],
    });
  }
}
