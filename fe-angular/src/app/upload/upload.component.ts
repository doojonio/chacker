import { Observable } from 'rxjs';

import {
  Component,
  ElementRef,
  EventEmitter,
  HostListener,
  Input,
  OnInit,
  Output,
  ViewChild,
} from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';

import { UploadService } from '../upload.service';
import { ImageShapeFormat, UploadedImage } from '../uploaded-image';
import {
  CropperDialogComponent,
  generateRecomendedMatDialogConfig,
} from './cropper-dialog/cropper-dialog.component';

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.scss'],
})
export class UploadComponent implements OnInit {
  @Output()
  fileUploaded = new EventEmitter<Observable<UploadedImage>>();
  @Input()
  imageShapeFormat: ImageShapeFormat = ImageShapeFormat.photo;
  @Input()
  imageMaxWidth = 0;
  @Input()
  imageMaxHeight = 0;
  @Input()
  imageMinSize = 0;
  @Input()
  imageMaxSize = 0;

  @ViewChild('fileInput')
  fileInput: ElementRef;

  private _cropperDialogRef: MatDialogRef<CropperDialogComponent>;

  constructor(
    private _uploadService: UploadService,
    private _matDialogService: MatDialog,
    private _snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {}

  public openFileExplorer() {
    const event = new MouseEvent('click', { bubbles: false });
    this.fileInput.nativeElement.dispatchEvent(event);
  }

  @HostListener('dragover', ['$event'])
  public PreventDefaultDragover(event: DragEvent) {
    event.preventDefault();
  }

  @HostListener('drop', ['$event'])
  public uploadDroppedFile(event: DragEvent) {
    event.preventDefault();
    const files = event.dataTransfer.files;
    if (!this._checkImageSize(files[0])) {
      return;
    }
    this._openCropperDialog(files[0]);
  }

  public uploadSelectedFile(files: FileList) {
    const file = files.item(0);
    if (!this._checkImageSize(file)) {
      return;
    }
    this._openCropperDialog(file);
  }

  private _checkImageSize(file: File) {
    let isLesserThenMaxSize = true;
    let isBiggerThenMinSize = true;

    if (this.imageMaxSize && file.size > this.imageMaxSize) {
      isLesserThenMaxSize = false;
      this._warn('You image is too big');
    }
    if (this.imageMinSize && file.size < this.imageMinSize) {
      isBiggerThenMinSize = false;
      this._warn('You image is too small');
    }

    return isLesserThenMaxSize && isBiggerThenMinSize;
  }

  private _warn(message: string) {
    this._snackBar.open(message, 'Close', { duration: 2000 });
  }

  private _uploadFile(file: File) {
    const response: Observable<UploadedImage> = this._uploadService.uploadImage(
      file
    );
    this.fileUploaded.emit(response);
  }

  private _openCropperDialog(file: File) {
    const dialogConfig = generateRecomendedMatDialogConfig();
    dialogConfig.data = {
      image: file,
      imageShapeFormat: this.imageShapeFormat,
      imageMaxHeight: this.imageMaxHeight,
      imageMaxWidth: this.imageMaxWidth,
    };
    this._cropperDialogRef = this._matDialogService.open(
      CropperDialogComponent,
      dialogConfig
    );

    this._cropperDialogRef.afterClosed().subscribe((croppedImage) => {
      if (croppedImage == null) {
        return;
      }
      this._uploadFile(croppedImage);
    });
  }
}
