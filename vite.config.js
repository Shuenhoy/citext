import { resolve } from 'path';
import { defineConfig } from 'vite';
import { viteSingleFile } from "vite-plugin-singlefile"
import license from 'rollup-plugin-license'

export default defineConfig({
    esbuild: {
        drop: ['console', 'debugger'],
    },
    define: {
        console: {}
    },
    plugins: [
        viteSingleFile(),
        license({
            thirdParty: {
                includePrivate: false,
                output: resolve(__dirname, 'package/dist/third-party-licenses.txt')
            }
        })
    ],
    resolve: {
        preserveSymlinks: true, // this is the fix!
    },
    build: {
        outDir: 'package/dist',
        minify: 'esbuild',
        cssCodeSplit: false,
        lib: {
            // Could also be a dictionary or array of multiple entry points
            entry: resolve(__dirname, 'index.js'),
            name: 'citext',
            // the proper extensions will be added
            fileName: 'index',
            formats: ['iife'],
        },
    },
});