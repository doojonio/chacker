import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { retry, tap } from 'rxjs/operators';
import { Challenge } from './entities/challenge-common';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class ChallengeService {
  private getUrl = environment.backendUrl + '/api/challenge';
  private createUrl = environment.backendUrl + '/api/challenge';

  constructor(private http: HttpClient) {}

  public list(): Observable<Challenge[]> {
    return this.http.get<Challenge[]>(this.getUrl).pipe(retry(3));
  }

  public getById(id: number): Observable<Challenge[]> {
    const params = new HttpParams().set('id', id.toString());
    return this.http
      .get<Challenge[]>(this.getUrl, { params })
      .pipe(retry(3));
  }

  public createChallenge(challenge: Challenge) {
    return this.http.post<any>(this.createUrl, challenge);
  }
}
