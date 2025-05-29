function vec=membership(xvector,varargin)
    args = struct(varargin{:});
    assert(isfield(args, 'type'),"type is not provided!")
    assert(isa(args.type, 'string'),"type needs to be a string")
    type=args.type;
    switch type
    case 'triangle'
        if isfield(args, 'start') && isfield(args, 'peak') && isfield(args, 'stop')
            assert(isa(args.start, 'double'),"start needs to be double")
            assert(isa(args.peak, 'double'),"peak needs to be double")
            assert(isa(args.stop, 'double'),"stop needs to be double")

            xvec = [args.start, args.peak, args.stop];
            yvec=[0,1,0];
            vec=profile_generator(xvector,xvec,yvec);
        elseif isfield(args, 'start') && isfield(args, 'width')
            assert(isa(args.start, 'double'),"start needs to be double")
            assert(isa(args.width, 'double'),"width needs to be double")

            xvec = [args.start,args.start+args.width/2 , args.start+args.width];
            yvec=[0,1,0];
            vec=profile_generator(xvector,xvec,yvec);
        else 
            vec=[]
            disp('Usage: membership("start",val,"peak",val,"stop",val)')
            disp('Usage: membership("start",val,"width",val)')
        end
    case 'trapezoid'
        if isfield(args, 'start_low') && isfield(args, 'start_high') && isfield(args, 'stop_high') && isfield(args, 'stop_low')
            assert(isa(args.start_low, 'double'),"start_low needs to be double")
            assert(isa(args.start_high, 'double'),"start_high needs to be double")
            assert(isa(args.stop_high, 'double'),"stop_high needs to be double")
            assert(isa(args.stop_low, 'double'),"stop_low needs to be double")

            xvec = [args.start_low,args.start_high, args.stop_high, args.stop_low];
            yvec=[0,1,1,0];
            vec=profile_generator(xvector,xvec,yvec);
        elseif isfield(args, 'start') && isfield(args, 'width_low') && isfield(args, 'width_high')
            assert(isa(args.start, 'double'),"start needs to be double")
            assert(isa(args.width_low, 'double'),"width_low needs to be double")
            assert(isa(args.width_high, 'double'),"width_high needs to be double")

            xvec = [args.start,args.start+args.width_low, args.start+args.width_low+args.width_high, args.start+args.width_low+args.width_high+args.width_low];
            yvec=[0,1,1,0];
            vec=profile_generator(xvector,xvec,yvec);
        else 
            vec=[]
            disp('Usage: membership("start_low",val,"start_high",val,"stop_high",val,"stop_low",val)')
            disp('Usage: membership("start",val,"width_low",val,"width_high",val)')
        end
    otherwise
        vec=[]
        disp("Type "+type+" not found!")
    end
end