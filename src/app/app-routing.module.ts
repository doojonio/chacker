import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { DashboardComponent } from './dashboard/dashboard.component';
import { WorkshopComponent } from './workshop/workshop.component';

const routes: Routes = [
  { path: '', component: DashboardComponent },
  { path: 'workshop', component: WorkshopComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
