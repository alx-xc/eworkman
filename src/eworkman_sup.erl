%%% 
%%% eworkman_sup: main supervisor
%%%
%%% Copyright (c) 2011 Megaplan Ltd. (Russia)
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"),
%%% to deal in the Software without restriction, including without limitation
%%% the rights to use, copy, modify, merge, publish, distribute, sublicense,
%%% and/or sell copies of the Software, and to permit persons to whom
%%% the Software is furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included
%%% in all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
%%% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
%%% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
%%% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
%%% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
%%% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%
%%% @author arkdro <arkdro@gmail.com>
%%% @since 2011-07-15 10:00
%%% @license MIT
%%% @doc main supervisor that spawns receiver, handler and child supervisor
%%% 

-module(eworkman_sup).
-behaviour(supervisor).

%%%----------------------------------------------------------------------------
%%% Exports
%%%----------------------------------------------------------------------------

-export([start_link/0, init/1]).

%%%----------------------------------------------------------------------------
%%% Defines
%%%----------------------------------------------------------------------------

-define(RESTARTS, 5).
-define(SECONDS, 2).

%%%----------------------------------------------------------------------------
%%% supervisor callbacks
%%%----------------------------------------------------------------------------
init(_Args) ->
    Handler = {
        eworkman_handler, {eworkman_handler, start_link, []},
        permanent, 1000, worker, [eworkman_handler]
        },
    LSup = {
        eworkman_long_sup, {eworkman_long_sup, start_link, []},
        transient, infinity, supervisor, [eworkman_long_sup]
        },
    {ok, {{one_for_one, ?RESTARTS, ?SECONDS},
        % LSup must be started before Handler
        [LSup, Handler]}}.
%%%----------------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------------
-spec start_link() -> any().
%%
%% @doc calls supervisor:start_link to create eworkman_supervisor
%%
start_link() ->
    supervisor:start_link({local, eworkman_supervisor}, eworkman_sup, []).
%%-----------------------------------------------------------------------------
