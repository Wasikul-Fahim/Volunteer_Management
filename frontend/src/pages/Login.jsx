import { Link } from "react-router-dom";

export default function Login() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-50 px-6 py-12">
      <section className="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
        <p className="text-sm font-semibold uppercase tracking-wider text-emerald-700">
          Phase 0 placeholder
        </p>
        <h1 className="mt-3 text-3xl font-bold text-slate-900">Log in</h1>
        <p className="mt-3 text-slate-600">
          Authentication will be implemented in Phase 2.
        </p>
        <Link className="mt-8 inline-block text-sm font-semibold text-emerald-700 hover:text-emerald-800" to="/">
          ← Back to landing page
        </Link>
      </section>
    </main>
  );
}
