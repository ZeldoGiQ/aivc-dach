import { readFile } from "node:fs/promises";
import { existsSync } from "node:fs";
import { computeCacheKey, templatePath } from "./cache";
import {
	completeJob,
	createJob,
	failJob,
	getJob,
	updateJob,
	type JobState,
} from "./job-store";
import { renderOverlay } from "./render";
import type { TemplateVars } from "./template-vars";

export interface OverlayMeta {
	id: string;
	name: string;
	type: "overlay";
	duration: number;
	aspectRatio: string;
	transparent: boolean;
	description: string;
	variables: Array<{
		key: string;
		label: string;
		type: "string" | "number" | "color" | "boolean";
		required: boolean;
		maxLength?: number;
		example?: string | number;
	}>;
	styleVars: Array<{
		key: string;
		label: string;
		type: "string" | "number" | "color";
		default: string | number;
	}>;
}

export interface StartOverlayJobInput {
	template: string;
	vars: TemplateVars;
	durationSeconds?: number;
	styleVars?: Record<string, string>;
	width?: number;
	height?: number;
}

const DEFAULT_WIDTH = 1920;
const DEFAULT_HEIGHT = 1080;

export async function loadOverlayMeta({
	template,
}: {
	template: string;
}): Promise<OverlayMeta> {
	const paths = templatePath({ template });
	if (!existsSync(paths.metaFile)) {
		throw new Error(`Template "${template}" has no meta.json`);
	}
	const raw = await readFile(paths.metaFile, "utf8");
	const parsed: OverlayMeta = JSON.parse(raw);
	if (typeof parsed?.id !== "string") {
		throw new Error(`meta.json for ${template} is malformed`);
	}
	return parsed;
}

export function startOverlayJob({
	template,
	vars,
	durationSeconds,
	styleVars,
	width,
	height,
	originBaseUrl,
}: StartOverlayJobInput & { originBaseUrl: string }): Promise<JobState> {
	return (async () => {
		const meta = await loadOverlayMeta({ template });
		const effectiveDuration = durationSeconds ?? meta.duration;
		const effectiveStyleVars = styleVars ?? {};
		const effectiveWidth = width ?? DEFAULT_WIDTH;
		const effectiveHeight = height ?? DEFAULT_HEIGHT;
		const hash = computeCacheKey({
			template,
			vars,
			durationSeconds: effectiveDuration,
			styleVars: effectiveStyleVars,
			width: effectiveWidth,
			height: effectiveHeight,
		});

		const job = createJob({ template, hash });

		// Fire-and-forget render. The route returns the job immediately.
		void runRender({
			jobId: job.id,
			template,
			vars,
			durationSeconds: effectiveDuration,
			styleVars: effectiveStyleVars,
			width: effectiveWidth,
			height: effectiveHeight,
			hash,
			originBaseUrl,
		}).catch((err: unknown) => {
			failJob({
				jobId: job.id,
				error: err instanceof Error ? err.message : String(err),
			});
		});

		return job;
	})();
}

async function runRender({
	jobId,
	template,
	vars,
	durationSeconds,
	styleVars,
	width,
	height,
	hash,
	originBaseUrl,
}: {
	jobId: string;
	template: string;
	vars: TemplateVars;
	durationSeconds: number;
	styleVars: Record<string, string>;
	width: number;
	height: number;
	hash: string;
	originBaseUrl: string;
}): Promise<void> {
	updateJob({ jobId, patch: { status: "running" } });
	try {
		await renderOverlay({
			template,
			vars,
			durationSeconds,
			styleVars,
			width,
			height,
			hash,
			onProgress: (progress) => {
				updateJob({ jobId, patch: { progress } });
			},
		});
		const fileUrl = `${originBaseUrl.replace(/\/$/, "")}/api/overlays/files/${hash}`;
		completeJob({ jobId, fileUrl });
	} catch (err) {
		failJob({
			jobId,
			error: err instanceof Error ? err.message : String(err),
		});
	}
}

export { getJob };
export type { JobState };
