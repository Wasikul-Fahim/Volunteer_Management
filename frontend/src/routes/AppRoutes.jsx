import { Route, Routes } from "react-router-dom";

import AppShell from "../components/AppShell";
import Campaigns from "../pages/Campaigns";
import Dashboard from "../pages/Dashboard";
import Donations from "../pages/Donations";
import Impact from "../pages/Impact";
import Login from "../pages/Login";
import Opportunities from "../pages/Opportunities";
import Register from "../pages/Register";
import Tasks from "../pages/Tasks";

export default function AppRoutes() {
  return (
    <Routes>
      <Route element={<AppShell />}>
        <Route path="/" element={<Dashboard />} />
        <Route path="/opportunities" element={<Opportunities />} />
        <Route path="/campaigns" element={<Campaigns />} />
        <Route path="/tasks" element={<Tasks />} />
        <Route path="/donations" element={<Donations />} />
        <Route path="/impact" element={<Impact />} />
      </Route>
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />
    </Routes>
  );
}
