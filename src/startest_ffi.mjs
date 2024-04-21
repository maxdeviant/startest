/** @param code {number} */
export function exit(code) {
  if (globalThis.Deno) {
    Deno.exit(code);
  } else {
    process.exit(code);
  }
}

/** @param module_path {string} */
export async function get_exports(module_path) {
  const module = await import(module_path);
  return Object.keys(module).map((export_name) => [
    export_name,
    module[export_name],
  ]);
}

export function do_run_tests(ctx, run) {
  return run(ctx);
}
