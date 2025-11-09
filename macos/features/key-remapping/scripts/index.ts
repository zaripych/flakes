import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

interface YabaiWindowFrame {
  x: number;
  y: number;
  w: number;
  h: number;
}

interface YabaiWindow {
  id: number;
  pid: number;
  app: string;
  title: string;
  scratchpad: string;
  frame: YabaiWindowFrame;
  role: string;
  subrole: string;
  "root-window": boolean;
  display: number;
  space: number;
  level: number;
  "sub-level": number;
  layer: string;
  "sub-layer": string;
  opacity: number;
  "split-type": string;
  "split-child": string;
  "stack-index": number;
  "can-move": boolean;
  "can-resize": boolean;
  "has-focus": boolean;
  "has-shadow": boolean;
  "has-parent-zoom": boolean;
  "has-fullscreen-zoom": boolean;
  "has-ax-reference": boolean;
  "is-native-fullscreen": boolean;
  "is-visible": boolean;
  "is-minimized": boolean;
  "is-hidden": boolean;
  "is-floating": boolean;
  "is-sticky": boolean;
  "is-grabbed": boolean;
}

/**
 * Executes a yabai command and parses the JSON output
 * @param args - Arguments to pass to yabai (e.g., ["-m", "query", "--windows"])
 * @returns Parsed JSON output from yabai
 */
export async function queryYabai<T = unknown>(args: string[]): Promise<T> {
  try {
    const { stdout } = await execFileAsync("yabai", args);
    return JSON.parse(stdout) as T;
  } catch (error) {
    throw new Error(
      `Failed to query yabai: ${
        error instanceof Error ? error.message : String(error)
      }`
    );
  }
}

/**
 * Executes a yabai command without expecting JSON output
 * @param args - Arguments to pass to yabai (e.g., ["-m", "window", "--focus", "west"])
 */
async function execYabai(args: string[]): Promise<void> {
  try {
    await execFileAsync("yabai", args);
  } catch (error) {
    throw new Error(
      `Failed to execute yabai command: ${
        error instanceof Error ? error.message : String(error)
      }`
    );
  }
}

interface YabaiSpace {
  id: number;
  uuid: string;
  index: number;
  label: string;
  type: string;
  display: number;
  windows: number[];
  "first-window": number;
  "last-window": number;
  "has-focus": boolean;
  "is-visible": boolean;
  "is-native-fullscreen": boolean;
}

interface YabaiDisplay {
  id: number;
  uuid: string;
  index: number;
  label: string;
  frame: YabaiWindowFrame;
  spaces: number[];
  "has-focus": boolean;
}

/**
 * Queries yabai for window information
 * @returns Array of window objects
 */
export async function getWindows(): Promise<YabaiWindow[]> {
  return queryYabai<YabaiWindow[]>(["-m", "query", "--windows"]);
}

/**
 * Queries yabai for space information
 * @returns Array of space objects
 */
export async function getSpaces(): Promise<YabaiSpace[]> {
  return queryYabai<YabaiSpace[]>(["-m", "query", "--spaces"]);
}

/**
 * Queries yabai for display information
 * @returns Array of display objects
 */
export async function getDisplays(): Promise<YabaiDisplay[]> {
  return queryYabai<YabaiDisplay[]>(["-m", "query", "--displays"]);
}

/**
 * Gets windows in the current space
 * @returns Array of windows in the current space
 */
async function getWindowsInCurrentSpace(): Promise<YabaiWindow[]> {
  return queryYabai<YabaiWindow[]>(["-m", "query", "--windows", "--space"]);
}

export async function focusLeftWindow(): Promise<void> {
  await execYabai(["-m", "window", "--focus", "west"]);
}

export async function focusRightWindow(): Promise<void> {
  await execYabai(["-m", "window", "--focus", "east"]);
}

export async function focusNorthWindow(): Promise<void> {
  await execYabai(["-m", "window", "--focus", "north"]);
}

export async function focusSouthWindow(): Promise<void> {
  await execYabai(["-m", "window", "--focus", "south"]);
}

export async function focusPrevSpace(): Promise<void> {
  await execYabai(["-m", "space", "--focus", "prev"]);
}

export async function focusNextSpace(): Promise<void> {
  await execYabai(["-m", "space", "--focus", "next"]);
}

export async function moveWindowToSpace(spaceNumber: number): Promise<void> {
  await execYabai([
    "-m",
    "window",
    "--space",
    spaceNumber.toString(),
    "--focus",
  ]);
}

export async function moveWindowToNextSpace(): Promise<void> {
  await execYabai(["-m", "window", "--space", "next", "--focus"]);
}

export async function moveWindowToPrevSpace(): Promise<void> {
  await execYabai(["-m", "window", "--space", "prev", "--focus"]);
}

export async function focusLeft(): Promise<void> {
  const windowsInSpace = await getWindowsInCurrentSpace();
  if (windowsInSpace.length > 1) {
    const sorted = windowsInSpace.sort((a, b) => a.frame.x - b.frame.x);
    if (sorted[0]?.["has-focus"]) {
      await focusPrevSpace();
    } else {
      await focusLeftWindow();
    }
  } else {
    await focusPrevSpace();
  }
}

export async function focusRight(): Promise<void> {
  const windowsInSpace = await getWindowsInCurrentSpace();
  if (windowsInSpace.length > 1) {
    const sorted = windowsInSpace.sort((a, b) => b.frame.x - a.frame.x);
    if (sorted[0]?.["has-focus"]) {
      await focusNextSpace();
    } else {
      await focusRightWindow();
    }
  } else {
    await focusNextSpace();
  }
}
