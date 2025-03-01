return (function()
    local v3=Vector3.new
    local cf=CFrame.new
    local angles=CFrame.Angles
    local deg=math.pi/180
    local new=Instance.new
    
    local data={
        --- optics
        ["Default Sight"]		={
            info="Stock gun sights."
        },
        ["Coyote Sight"]		={
            info				="Chinese pale red dot sight for quick target acquisition and pinpoint accuracy.",
            unlockkills			=0,
            stats={
                zoom				=2.4,
            },
        },
        ["Reflex Sight"]		={
            info				="Trijicon reflext sight that offer shooters the perfect combination of speed and precision under virtually any lighting conditions.",
            unlockkills			=0,
            stats={
                zoom				=2,
            },
        },
        ["Kobra Sight"]			={
            info				="Russian red dot combat optic using laser-generated HUD technology to superimpose a reticle pattern onto a filtered lens.",
            unlockkills			=0,
            stats={
                zoom				=2.7,
            },
        },
        ["EOTech XPS2"]			={
            info				="Shortest, smallest and lightest EOTech model holographic weapon sight to improve target acquisition.",
            unlockkills			=0,
            stats={
                zoom				=2.5,
            },
        },
        ["EOTech 552"]			={
            info				="Model 552 is the model of choice for elite military forces designed for close-in combat speed and versatility.",
            unlockkills			=0,
            stats={
                zoom				=2.2,
            },
        },
        ["MARS"]				={
            info				="Multi-Purpose Aiming Reflex Sight, high grade fast action red dot sight for accurate high performance sighting in tactical situations.",
            unlockkills			=0,
            stats={
                zoom				=2.8,
            },
        },
        ["C79"]					={
            info				="Standard Canandian scope that delivers exceptional optical clarity and light gathering ability, allowing it to significantly improve hit probability at extended ranges.",
            unlockkills			=0,
            stats={
                zoom				=3.5,
            },
        },
        ["PK-A"]				={
            info				="Russian high power scope perfectly suited for high density urban suppression and picking up fast moving targets",
            unlockkills			=0,
            stats={
                zoom				=3.8,
            },
        },
        ["Comp Aimpoint"]		={
            info				="Passive red dot collimator reflex sight which offers superior situational awareness by un-cluttering the surrounding field of view.",
            unlockkills			=0,
            stats={
                zoom				=3,
            },
        },
        ["Z-Point"]				={
            info				="Reflex sight designed for hunters who need fast target acquisition with lightning reflexes while firing accurate shots in quick succession.",
            unlockkills			=0,
            stats={
                zoom				=1.5,
            },
        },
        ["M145"]				={
            info				="A variant of the C79 optical scope combining ELCAN's legendary robustness and optical brilliance with a ballistically calibrated LED-illuminated ranging reticle",
            unlockkills			=0,
            stats={
                zoom				=3.5,
                aimwalkspeedmult	=0.5,
            },
        },
        ["PKA-S"]				={
            info				="Advanced russian red dot collimator scope sight for mid to close range engagements with an open sight picture.",
            unlockkills			=0,
            stats={
                zoom				=3.5,
                aimwalkspeedmult	=0.5,
            },
        },
        ["Acog Scope"]			={
            info				="Advanced Combat Optical Gunsight, a fixed power compact riflescope combining traditional and precise distance marksmanship with CQB speed.",
            unlockkills			=0,
            stats={
                zoom				=3.8,
                aimwalkspeedmult	=0.5,
            },
        },
        ["Vcog 6x Scope"]		={
            info				="Variable Combat Optical Gunsight, a scope engineered to accommodate Close Quarters Combat (CQB) as well as long range shooting with superior class and rugged construction.",
            unlockkills			=0,
            stats={
                zoom				=6,
                aimrotkickmin		=v3(0,-0,-0),
                aimrotkickmax		=v3(0,-0,-0),
                aimwalkspeedmult	=0.5,
                blackscope			=true,
                scopeid				="http://www.roblox.com/asset/?id=296810337",
            },
        },
        
        --- pistol sights
        ["Delta Sight"]			={
            info				="Compact delta reticle sight that allows for a single point sight picture for an extremely simple, accurate shot placement",
            unlockkills			=0,
            stats={
    
            },
        },
        ["Mini Sight"]			={
            info				="Mini Red Dot Sight (MRDS) is designed to aid rapid target acquisition at close combat distances for high visibility in all lighting conditions.",
            unlockkills			=0,
            stats={
    
            },
        },
        ["Full Ring Sight"]		={
            info				="Iron ring sight with a thin ring to minimize occlusion of the target, and a thicker front post for rapid target acquisition.",
            unlockkills			=0,
            stats={
    
            },
        },
        ["Half Ring Sight"]		={
            info				="Half ring ghost sight to aid in balanced visibility and rapid target acquisition at shorter ranges.",
            unlockkills			=0,
            stats={
    
            },
        },
        
        --- barrel
        ["R2 Suppressor"]		={
            info				="Western compact medium range suppressor with an effective masking range of 35 studs and beyond. Reduces muzzle velocity by 40 percent.",
            unlockkills			=0,
            stats={
                firepitch			=7,
                hideflash			=true,
                hideminimap			=true,
                hiderange			=35,
            },
            mods={
                damage0				=0.95,
                damage1				=0.9,
                range0				=0.8,
                range1				=0.75,
                bulletspeed			=0.6,
                hipfirestability	=1.1,
                firevolume			=0.8,
            }
        },
        ["ARS Suppressor"]		={
            info				="Light suppressor with an `effective masking range of 60 studs and beyond. Reduces muzzle velocity by 30 percent.",
            unlockkills			=0,
            stats={
                firepitch			=5,
                hideflash			=true,
                hideminimap			=true,
                hiderange			=60,
            },
            mods={
                damage0				=1,
                damage1				=0.95,
                range0				=0.9,
                range1				=0.85,
                bulletspeed			=0.7,
                hipfirestability	=1.1,
                firevolume			=0.9,
            }
        },
        ["PBS-1 Suppressor"]	={
            info				="Light Russian suppressor with effective masking range of 80 studs and beyond. Reduces muzzle velocity by 20 percent.",
            unlockkills			=0,
            stats={
                firepitch			=4,
                hideflash			=true,
                hideminimap			=true,
                hiderange			=80,
            },
            mods={
                damage0				=1,
                damage1				=0.93,
                range0				=0.9,
                range1				=0.9,
                bulletspeed			=0.8,
                hipfirestability	=1.1,
                firevolume			=0.9,
            }
        },
        ["PBS-4 Suppressor"]	={
            info				="Medium Russian suppressor with effective masking range of 45 studs and beyond. Reduces muzzle velocity by 30 percent.",
            unlockkills			=0,
            stats={
                firepitch			=6.5,
                hideflash			=true,
                hideminimap			=true,
                hiderange			=45,
            },
            mods={
                damage0				=0.95,
                damage1				=0.9,
                range0				=0.8,
                range1				=0.85,
                bulletspeed			=0.7,
                hipfirestability	=1.1,
                firevolume			=0.9,
            }
        },
        ["Suppressor"]			={
            info				="Standard heavy suppressior with highly effective masking range of 25 studs and beyond. Drastically reduces muzzle velocity by 50 percent.",
            unlockkills			=0,
            stats={
                firepitch			=8,
                hideflash			=true,
                hideminimap			=true,
                hiderange			=25,
            },
            mods={
                damage0				=0.95,
                damage1				=0.8,
                range0				=0.7,
                range1				=0.7,
                bulletspeed			=0.5,
                hipfirestability	=1.1,
                firevolume			=0.9,
            }
        },
        ["Flash Hider"]			={
            info				="Eliminates visible muzzle flash while firing by cooling or dispersing burning gases that exit the muzzle, resulting in slightly reduced stability.",
            unlockkills			=0,
            stats={
                hideflash			=true,
            },
            mods={
                modelkickspeed		=0.9,
                hipfirestability	=0.9,
            },
        },
        ["Muzzle Brake"]		={
            info				="Reduces vertical recoil climb while firing by dispersing muzze gas to the side. Trade off in slightly increased horizontal recoil drifting.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                hipfirestability	=0.85,
                hipfirespread		=1.1,
                camkickmax			=v3(0.85,1.15,1),
                aimcamkickmin		=v3(0.8,1.15,1),
                aimcamkickmax		=v3(0.8,1.15,1),
            },
            
        },
        ["Compensator"]			={
            info				="Reduces horizontal recoil drifting while firing by dispersing muzze gas to the top. Trade off in slightly increased vertical recoil climb.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                hipfirestability	=0.95,
                hipfirespread		=1.05,
                camkickmax			=v3(1.1,0.7,1),
                aimcamkickmin		=v3(1.05,0.5,0.5),
                aimcamkickmax		=v3(1.05,0.5,0.5),
            },
        },
    
        --- underbarrel
        ["Vertical Grip"]		={
            info				="Improves hipfire stability and gun recoil recovery while reducing hipfire spread. Rougher recoil handling while aiming sights.",
            unlockkills			=0,
            stats={
                
            },
            mods={
                modelkickspeed		=1.05,
                rotkickmax			=0.8,
                hipfirespreadrecover=1.15,
                hipfirespread		=0.8,
                hipfirestability	=1.1,
    
                camkickmin			=1.05,
                camkickmax			=1.05,
                aimcamkickmin		=1.05,
                aimcamkickmax		=1.05,
                aimrotkickmax		=1.05,
                equipspeed			=0.9,
                aimspeed			=0.85,
            }
        },
        ["Angled Grip"]			={
            info				="Balanced reduction in blowback recoil effect on gun in both hipfire and aimed fire. Increased hipfire spread and light increase in gun torque recoil.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                camkickmin			=0.85,
                camkickmax			=0.95,
                aimcamkickmin		=0.9,
                aimcamkickmax		=0.85,
    
                hipfirespread		=1.15,
                aimrotkickmax		=1.05,
                rotkickmax			=1.05,
                equipspeed			=0.9,
                aimspeed			=0.85,
            }
        },
        ["Folding Grip"]		={
            info				="Reduces blowback recoil effect on gun in both hipfire and aimed fire significantly. Reduced hipfire stability, increased hipfire spread and gun torque recoil.",
            unlockkills			=0,
            stats={
                
            },
            mods={
                camkickmin			=0.8,
                camkickmax			=0.9,
                aimcamkickmin		=0.85,
                aimcamkickmax		=0.9,
    
                hipfirespread		=1.15,
                hipfirestability	=0.9,
                aimrotkickmax		=1.15,
                rotkickmax			=1.15,
                equipspeed			=0.9,
                aimspeed			=0.85
            }
        },
        ["Stubby Grip"]			={
            info				="Reduces blowback recoil effect in aimed fire and overall gun torque recoil. Reduced gun handling stability and increased hipfire spread.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                aimcamkickmin		=0.9,
                aimcamkickmax		=0.9,
                modelkickdamper		=0.8,
                hipfirespread		=0.8,
    
                hipfirestability	=0.8,
                aimrotkickmax		=0.95,
                rotkickmax			=0.9,
                equipspeed			=0.9,
                aimspeed			=0.85
            }
        },
    
        --- other
        ["Laser"]				={
            info				="Improves gun recoil recovery speed and hipfire stability.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                modelkickspeed		=1.05,
                hipfirestability	=1.05,
            }
        },
        ["Green Laser"]			={
            info				="Reduces random hipfire spread and improves gun recoil recovery speed.",
            unlockkills			=0,
            stats={
    
            },
            mods={
                modelkickspeed		=1.05,
                hipfirespread		=0.8,
            }
        },
        ["Canted Iron Sight"]	={
            info				="Additional iron sights for rapid shift from primary optics for favorable performance in close-range engagements.",
            unlockkills			=0,
            stats={
                altsight			="SightMark2",
                altaimspeed			=16,
                altaimwalkspeedmult	=0.6,
                altzoom				=2,
            },
            mods={
                
            }
        },
        ["Canted Delta Sight"]	={
            info				="Additional modified delta reflex sight for clean optimal target acquisition in close-range engagements.",
            unlockkills			=0,
            stats={
                altsight			="SightMark2",
                altaimspeed			=16,
                altaimwalkspeedmult	=0.6,
                altzoom				=2,
            },
            mods={
    
            }
        },
        ["Ballistics Tracker"]={
            info		="Tracks a range of targets and computes the optimal firing trajectory to achieve a headshot.";
            unlockkills	=0;
            stats={
                node				="OtherNode"
            },
            mods		={};
        },
        
    
        [""]={info=""},
    }
    
    return data end)()