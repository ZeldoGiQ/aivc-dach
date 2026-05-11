import { z } from "zod";
import { startOverlayJob } from "@/services/overlay-renderer";

export const runtime = "nodejs";
export const maxDuration = 60;

const requestSchema = z.object({
	template: z.string().min(1),
	vars: z.record(z.string(), z.union([z.string(), z.number(), z.null()])),
	durationSeconds: z.number().positive().optional(),
	styleVars: z.record(z.string(), z.string()).optional(),
	width: z.number().int().positive().max(7680).optional(),
	height: z.number().int().positive().max(7680).optional(),
});

export async function POST(req: Request) {
	let body: unknown;
	try {
		body = await req.json();
	} catch {
		return Response.json({ error: "invalid JSON body" }, { status: 400 });
	}

	const parsed = requestSchema.safeParse(body);
	if (!parsed.success) {
		return Response.json(
			{ error: parsed.error.message },
			{ status: 400 },
		);
	}

	const url = new URL(req.url);
	const originBaseUrl = `${url.protocol}//${url.host}`;

	try {
		const job = await startOverlayJob({
			template: parsed.data.template,
			vars: parsed.data.vars,
			durationSeconds: parsed.data.durationSeconds,
			styleVars: parsed.data.styleVars,
			width: parsed.data.width,
			height: parsed.data.height,
			originBaseUrl,
		});
		return Response.json({
			jobId: job.id,
			status: job.status,
			template: job.template,
			hash: job.hash,
		});
	} catch (err) {
		return Response.json(
			{ error: err instanceof Error ? err.message : String(err) },
			{ status: 500 },
		);
	}
}
