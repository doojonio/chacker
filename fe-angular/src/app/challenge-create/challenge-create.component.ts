import { Observable } from 'rxjs';

import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';

import { Challenge } from '../challenge';
import { ChallengeService } from '../challenge.service';
import { Task } from '../task';
import { ImageShapeFormat, UploadedImage } from '../uploaded-image';

@Component({
  selector: 'app-challenge-create',
  templateUrl: './challenge-create.component.html',
  styleUrls: ['./challenge-create.component.scss'],
})
export class ChallengeCreateComponent implements OnInit {
  challengeUploadedImage: UploadedImage;
  challengeFormGroup: FormGroup;
  tasks: Task[] = [];

  CHALLENGE_IMAGE_FORMAT = ImageShapeFormat.wide;

  constructor(
    private _fb: FormBuilder,
    private _challengeService: ChallengeService,
    private _router: Router,
  ) {}

  ngOnInit(): void {
    this.challengeFormGroup = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
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

  finish() {
    if (!this._isFormValid()) {
      return;
    }
    const challenge = this.challengeFormGroup.value as Challenge;
    challenge.tasks = this.tasks;
    challenge.picture = this.challengeUploadedImage;

    this._challengeService.create(challenge).subscribe(
      createResult => {
        this._router.navigate([createResult.id])
      }
    );
  }

  private _isFormValid() {
    let isFieldsAreValid = this.challengeFormGroup.valid && this.tasks.length > 0;
    let isWallpaperChoosed = !!this.challengeUploadedImage;

    return isFieldsAreValid && isWallpaperChoosed;
  }
}
