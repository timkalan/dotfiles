return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		{
			"leoluz/nvim-dap-go",
			opts = {},
		},
	},
	keys = {
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[d]ebug: toggle [b]reakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "[d]ebug: conditional [B]reakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "[d]ebug: [c]ontinue / start",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "[d]ebug: step [i]nto",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "[d]ebug: [n]ext (step over)",
		},
		{
			"<leader>df",
			function()
				require("dap").step_out()
			end,
			desc = "[d]ebug: [f]inish (step out)",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "[d]ebug: run to [C]ursor",
		},
		{
			"<leader>dt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "[d]ebug: nearest [t]est",
		},
		{
			"<leader>dl",
			function()
				require("dap-go").debug_last_test()
			end,
			desc = "[d]ebug: [l]ast test",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[d]ebug: toggle [r]epl",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "[d]ebug: toggle [u]i",
		},
		{
			"<leader>dx",
			function()
				require("dap").terminate()
			end,
			desc = "[d]ebug: terminate / e[x]it",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval(nil, { enter = true })
			end,
			mode = { "n", "v" },
			desc = "[d]ebug: [e]val expression",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Go is handled by dap-go; Rust needs the adapter wired up by hand
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.rust = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				program = function()
					local target = vim.fn.getcwd() .. "/target/debug/"
					return vim.fn.input("Path to executable: ", target, "file")
				end,
			},
		}
	end,
}
