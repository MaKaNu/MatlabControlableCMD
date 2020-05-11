%% Launch a new cmd window with specific title

system(['start "CMD_01" cmd.exe ', ... % New CMD with Title 'CMD_01'
	'/c ', ...									% Close CMD (/k left the cmd open)
	'.\testbatch.bat'])						% Programm to run inside the CMD

[st,out] = system(['tasklist',...		% list all active processes
	'/FI "WINDOWTITLE eq CMD_01*"'],...	% Filters for Wildcard CMD_01*
	'-echo'); 

% WILDCARD is only working at the end position for this filter

%% Create a table from the Output 
% (WORKS ONLY FOR TASKLIST output without verbose)

out_frmt = regexprep(out, '\sK','K');				% Remove Space in last cell
out_frmt = regexprep(out_frmt,' +',',');			% Replace spaces with komma
out_frmt = [out_frmt(2:55) out_frmt(136:end)];	% Remove Hline
HeaderFmt = '%s%s%s%s%s';
DataFmt = '%s%f%s%f%s';
Fields = cellfun(@(x) x{1}, textscan(out_frmt,... % Headline
	HeaderFmt, 1,...
	'Delimiter', ','), 'un', 0);
Data = textscan(out_frmt,...
	DataFmt,...
	'Headerlines', 1,...
	'EndOfLine', newline,...
	'Delimiter', ',');
Table = table(Data{:}, 'VariableNames', Fields);

%% Kill the specific Process

if numel(Table.PID) == 1
	system(strcat('taskkill /pid ',{' '},string(Table.PID)))
else
	warning('Too many windows with same title!')
end
