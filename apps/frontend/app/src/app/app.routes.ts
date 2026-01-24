import { Routes } from '@angular/router';
import { HelloPage } from './features/hello/pages/hello-page/hello-page';
import { HealthPage } from './features/health/pages/health-page/health-page';
import { UserListPage } from './features/users/pages/user-list-page/user-list-page';

export const routes: Routes = [
    {path: '', redirectTo: 'hello', pathMatch: 'full'},
    {path: 'hello', component: HelloPage},
    {path: 'health', component: HealthPage},
    {path: 'users', component: UserListPage}
];
