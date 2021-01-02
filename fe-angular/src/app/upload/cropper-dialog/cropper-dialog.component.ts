import { base64ToFile, ImageCroppedEvent } from 'ngx-image-cropper';
import { ImageShapeFormat } from 'src/app/uploaded-image';

import { Component, Inject, Input, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogConfig, MatDialogRef } from '@angular/material/dialog';

export function generateRecomendedMatDialogConfig(): MatDialogConfig {
  const config: MatDialogConfig = {
    autoFocus: true,
    maxHeight: 500,
    maxWidth: '60%',
  };
  return config;
}

@Component({
  selector: 'app-cropper-dialog',
  templateUrl: './cropper-dialog.component.html',
  styleUrls: ['./cropper-dialog.component.scss']
})
export class CropperDialogComponent implements OnInit {
  image: File;
  aspectRatio: number;
  cropperMaxWidth: number;
  cropperMaxHeight: number;

  private _croppedImage: Blob;

  constructor(
    public dialogRef: MatDialogRef<CropperDialogComponent>,
    @Inject(MAT_DIALOG_DATA)
    public data: any,
  ) {
    this.image = data.image;
    this.aspectRatio = (data.imageShapeFormat || ImageShapeFormat.photo) as number;
    this.cropperMaxHeight = data.imageMaxHeight || 0;
    this.cropperMaxWidth = data.imageMaxWidth || 0;
  }

  ngOnInit(): void {}

  handleCroppedImage(event: ImageCroppedEvent) {
    this._croppedImage = base64ToFile(event.base64);
  }

  saveAndClose() {
    const fileName = this.image.name;
    const croppedImageAsFile = new File([this._croppedImage], fileName)
    this.dialogRef.close(croppedImageAsFile);
  }

  justClose() {
    this.dialogRef.close();
  }
}
