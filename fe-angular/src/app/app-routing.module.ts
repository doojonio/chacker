import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { ChallengeDetailsComponent } from './challenge-details/challenge-details.component';

const routes: Routes = [
  {
    path: ':challengeId',
    component: ChallengeDetailsComponent,
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
